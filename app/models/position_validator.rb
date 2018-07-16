class PositionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || value.empty?
      return
    end

    unless User.POSITIONS.include? value
      record.errors[attribute] << (options[:message] || 'is not a position')
    end
  end
end