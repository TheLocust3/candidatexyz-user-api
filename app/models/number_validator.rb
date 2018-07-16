class NumberValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        if value.nil? || value == ''
            return
        end

        unless value =~ /^[0-9]*$$/
            record.errors[attribute] << (options[:message] || 'contains non-numbers')
        end
    end
end