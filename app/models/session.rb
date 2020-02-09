# == Schema Information
#
# Table name: sessions
#
#  id         :bigint           not null, primary key
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :string           not null
#
# Indexes
#
#  index_sessions_on_session_id  (session_id) UNIQUE
#  index_sessions_on_updated_at  (updated_at)
#

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Session < ApplicationRecord
  attribute :key
  enum key: {
    login_id: "gldi",
    crypt_pwd: "cdwp"
  }
end
