class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include CustomValidators

  scope :deleted, -> { where.not(deleted_at: nil)}
  scope :active, -> { where(deleted_at: nil)}
  scope :column_symbols, -> { column_names.map(&:to_sym) }
  scope :like, ->(column, word) { where("`#{table_name}`.`#{column}` LIKE ?", "%#{word}%") }
  scope :less, ->(column, value) { where("`#{table_name}`.`#{column}` <= ?", value) }
  scope :more, ->(column, value) { where("`#{table_name}`.`#{column}` >= ?", value) }
#  records_with_operator_on :create, :update, :destroy

  # 論理削除
  def logical_delete!
    self.deleted_at = Time.zone.now
    self.deleted_by = operator.try(:id)
    self.save!(validate: false)
  end

  def deleted?
    self.deleted_at.present?
  end

  def active?
    self.deleted_at.blank?
  end

  def self.between(column, from, to)
    if from.present? && to.present?
      self.where(column => from..to)
    elsif from.present?
      self.more(column, from)
    elsif to.present?
      self.less(column, to)
    else
      all
    end
  end
end
