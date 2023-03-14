class ImportEmployees
  require 'roo'
  require 'csv'

  def call(file, company)
    spreadsheet = Roo::Spreadsheet.open(file.tempfile.path, extension: :xlsx).sheet(0)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user_hash = row.to_hash
      user_hash[:company_id] = company.id
      employee = Employee.create(user_hash)
      if employee.errors.any?
        error_row = spreadsheet.row(i)
          error_row << employee.errors.full_messages.last
        puts "-------#{error_row}"
        CSV.open('validation_error.csv', 'a+') do |csv|
          csv << error_row
        end
      end
    end

  end
end