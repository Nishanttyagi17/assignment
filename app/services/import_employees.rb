class ImportEmployees
  require 'csv'

  def call(file, company)
    csv_data = CSV.read(file.path, headers: true)
    csv_data.each do |row|
      user_hash = row.to_hash
      user_hash[:company_id] = company.id
      employee = Employee.create(user_hash)
      if employee.errors.any?
        row["error"] = employee.errors.full_messages
        CSV.open('validation_error.csv', 'a+') do |csv|
          csv << row
        end
      end
    end

  end
end