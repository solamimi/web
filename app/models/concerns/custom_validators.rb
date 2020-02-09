# coding: utf-8
module CustomValidators

  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A(([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,}))*\z/i
        record.errors[attribute] << (options[:message] || "メールアドレスの形式に誤りがあります。")
      end
    end
  end

  # 郵便番号
  class ZipValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\d{3}-\d{4}/
        record.errors[attribute] << (options[:message] || "-（ハイフン）を含み、半角数字7桁で入力してください。")
      end
    end
  end

  # TELL,FAX
  class TelValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\d{2,4}-\d{2,4}-\d{4}/
        record.errors[attribute] << (options[:message] || "半角数字、-（ハイフン）で入力してください。")
      end
    end
  end

  # 半角英数字
  class EisuValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A[a-z0-9]*\z/i
        record.errors[attribute] << (options[:message] || "半角英数字で入力してください。")
      end
    end
  end

  # ピリオド込み半角英数字
  class EisuWithPeriodValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A[a-z0-9.-]*\z/i
        record.errors[attribute] << (options[:message] || "半角英数字もしくは .（ピリオド）で入力してください。")
      end
    end
  end

  # アンダーバー込み半角英数字
  class EisuWithUnderbarValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A[a-z0-9_]*\z/i
        record.errors[attribute] << (options[:message] || "半角英数字もしくは _（アンダーバー）で入力してください。")
      end
    end
  end

  # 半角数字
  class NumValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A[0-9]*\z/i
        record.errors[attribute] << (options[:message] || "半角数字で入力してください。")
      end
    end
  end

  #カンマ付数値チェック
  class NumWithCommaValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless record.read_attribute_before_type_cast(attribute).to_s =~ /\A[-+]?[0-9]*\z/i #再表示かつ変更なしの場合には数値項目となってしまう為文字列へ変換
        record.errors[attribute] << (options[:message] || Msg.get((38), "半角整数"))
        record[attribute] = nil #不正項目をクリアする（自動castされた値は表示しない）
      end
    end
  end

  # カナ
  class KanaValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~/^[\p{katakana}\p{blank}ー－ｰﾞﾟ・･.]*$/
        record.errors[attribute] << (options[:message] || "カナ入力してください。")
      end
    end
  end

  # メール配信用アドレス名
  class MailUserNameValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~/\A[a-zA-Z0-9\._-]*\z/
        record.errors[attribute] << (options[:message] || "半角英数字もしくは -(ハイフン) .（ピリオド） _（アンダーバー） で入力してください。")
      end
    end
  end

  # メール転送受付用アドレス名
  class MailUserNameWithoutDotsValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~/\A[a-zA-Z0-9_-]*\z/
        record.errors[attribute] << (options[:message] || "半角英数字もしくは -(ハイフン) _（アンダーバー） で入力してください。")
      end
    end
  end

  # 禁則文字
  class KinsokuValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      unless value =~ /\A[u"[　、。，．・：；？！＼゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼～∥｜…‥‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰♯♭♪†‡¶◯]+|[α-ω]+|[А-Я]+|[а-я]+|[一-龠]+|[ぁ-ん]+|[ァ-ヶ]+|[０-９Ａ-Ｚａ-ｚ]+|[\s!-~]+"]*\z/
        record.errors[attribute] << (options[:message] || "禁則文字（半角カナ、機種依存文字【①やⅢ】）が含まれています。")
      end
    end
  end

  class UniqunessWithDeletedValidator < ActiveRecord::Validations::UniquenessValidator
    def validate_each(record, attribute, value)
      if record.active?
        finder_class = find_finder_class_for(record)
        value = map_enum_attribute(finder_class, attribute, value)

        relation = build_relation(finder_class, attribute, value)
        if record.persisted?
          if finder_class.primary_key
            relation = relation.where.not(finder_class.primary_key => record.id_in_database || record.id)
          else
            raise UnknownPrimaryKey.new(finder_class, "Can not validate uniqueness for persisted record without primary key.")
          end
        end
        relation = scope_relation(record, relation)
        relation = relation.merge(options[:conditions]) if options[:conditions]

        # 追記分
        relation = relation.active

        if relation.exists?
          error_options = options.except(:case_sensitive, :scope, :conditions)
          error_options[:value] = value

          # record.errors.add(attribute, :taken, error_options)
          # customize
          record.errors.add(:base, :taken, error_options)
          record.errors.add(attribute, "")
          unless options[:scope].nil?
            if options[:scope].instance_of?(Array)
              options[:scope].each do |sc|
                record.errors.add(sc, "")
              end
            end
          end
        end
      end
    end
  end


  # 本文に禁止文字が含まれていないこと
  # 含まれていれば該当文字の行数と禁則文字を表示
  class KinsokuWithIndexValidator < ActiveModel::EachValidator

    REGEXP = /\A[u"[　、。，．・：；？！＼゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼～∥｜…‥‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰♯♭♪†‡¶◯]+|[α-ω]+|[А-Я]+|[а-я]+|[一-龠]+|[ぁ-ん]+|[ァ-ヶ]+|[０-９Ａ-Ｚａ-ｚ]+|[\s!-~]+"]+\z/

    def validate_each(record, attribute, value)
      return nil if value.blank? || REGEXP =~ value
      # エラー文字の取得
      index, kinsokumoji = get_kinsimoji(value)
      record.errors.add(attribute, :kinsoku_with_index, index: index + 1, kinsokumoji: kinsokumoji)
    end

    private

      def get_kinsimoji(body)
        lines = body.split(/\n/)
        lines.each_with_index do |line, index|
          result = get_kinsimoji_from_line(line)
          return index, result unless result.blank?
        end
        return -1, ""
      end

      def get_kinsimoji_from_line(line)
        return "" if REGEXP =~ line
        len = line.mb_chars.length
        case len
        when 0 then ""
        when 1 then
          if REGEXP =~ line then "" else line end
        else
          half_pos = len / 2
          mae_text = line.mb_chars.first(half_pos)
          ato_text = line.mb_chars.from(half_pos)
          if REGEXP =~ mae_text then get_kinsimoji_from_line(ato_text) else get_kinsimoji_from_line(mae_text) end
        end
      end
  end

end
