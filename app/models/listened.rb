# coding: utf-8

# == Schema Information
#
# Table name: listeneds
#
#  id            :bigint           not null, primary key
#  created_by    :integer
#  deleted_at    :datetime
#  deleted_by    :integer
#  listen_at     :datetime
#  listen_origin :string
#  listen_words  :string
#  lock_version  :integer          default(0), not null
#  updated_by    :integer
#  value         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer
#

require 'google/apis/sheets_v4'
require "googleauth"


class Listened < ApplicationRecord
  SHEET_ID = "15uqxj5YSYxbc-wK7hi-b65GrrT9n-0eJ8hNXfhBsiqE"
  COLUMNS = {
    created_at: :A,
    listen_at: :B,
    created_by: :C,
    updated_at: :D,
    updated_by: :E,
    user: :F,
    listen_words: :G,
    value: :H
  }



  def self.google_drive
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: ENV['G_CLIENT_ID'],
      client_secret: ENV['G_CLIENT_SECRET'],
      scope: %w(https://www.googleapis.com/auth/drive https://spreadsheets.google.com/feeds/),
      redirect_uri: 'urn:ietf:wg:oauth:2.0:oob'
    )
    credentials.refresh_token = ENV["G_REFRESH_TOKEN"]
    credentials.fetch_access_token!
    GoogleDrive::Session.from_credentials(credentials)
  end

  def self.sheet
    session = self.google_drive
    session.spreadsheet_by_key(SHEET_ID).worksheet_by_title("Listened")
  end

  def self.insert(hash={})
    sheet = self.sheet
    row = sheet.num_rows + 1
    hash.each do |col, val|
      cell = "#{COLUMNS[col.to_sym]}#{row}"
      puts cell
      sheet[cell] = val
    end
    sheet.save
  end

  class Search
    include ActiveModel::Model
    include ActiveModelBase

    attr_accessor :listen_words, :listen_origin, :listen_at_from, :listen_at_to, :user_id_from, :user_id_to, :value_from, :value_to

          type_int :user_id_from, :user_id_to, :value_from, :value_to

    def search(page)
      model = Listened.active



      model = model.between(:user_id, self.user_id_from, self.user_id_to)

      model = model.like(:listen_words, "%#{self.listen_words}%") if self.listen_words.present?

      model = model.like(:listen_origin, "%#{self.listen_origin}%") if self.listen_origin.present?

      model = model.between(:value, self.value_from, self.value_to)

      model.page(page)
    end
  end
end
