require 'yaml'
MESSAGES = YAML.load_file("loan_calculator_messages.yml")
LANGUAGE = 'en', 'es'

def messages(lang, message)
  MESSAGES[LANGUAGE[lang]][message]
end

def prompt(lang, key)
  message = messages(lang, key)
  puts "=> #{message}"
end

def which_language?(lang)
  loop do
    lang = gets.chomp
    if lang == '1'
      lang = 0
      break
    elsif lang == '2'
      lang = 1
      break
    else
      prompt(0, 'invalid_num')
    end
  end
  lang
end

def float_or_integer?(valid_number)
  if valid_number.to_f == valid_number.to_i
    valid_number.to_i
  else
    valid_number.to_f
  end
end

def valid_num?(lang, number)
  loop do
    number = gets.chomp
    if (number == number.to_i.to_s || number == number.to_f.to_s) && number.to_f.positive?
      break
    else
      prompt(lang, 'invalid_num')
    end
  end
  float_or_integer?(number)
end

def apr_conversion(lang, number)
  prompt(lang, 'input_interest')
  number = valid_num?(lang, number)
  apr_rate = (number.to_f / 12) * 0.01
  apr_rate
end

def loan_term(lang, number)
  prompt(lang, 'duration_in_years')
  years = valid_num?(lang, number).to_i
  prompt(lang, 'duration_in_months')
  months = valid_num?(lang, number).to_i
  total_months = (years * 12) + months
  number = years, months, total_months
  number
end

def result_screen(amount, apr, duration, monthly_payment)
  puts "Loan Amount: $#{amount.to_f}"
  puts "APR: %#{((apr * 12) / 0.01).to_i}"
  puts "Duration: #{duration[0]} years, #{duration[1]} months = #{duration[2]} months"
  puts "Total, Monthly Payment = $#{monthly_payment.truncate(2)}"
end

loan_amount = 0
monthly_payment = 0
apr = 0
loan_duration = 0

lang_select = 0
prompt(lang_select, 'lang_selection')
lang_select = which_language?(lang_select)

prompt(lang_select, 'welcome')
loop do # main loop
  prompt(lang_select, 'input_loan')
  loan_amount = valid_num?(lang_select, loan_amount)
  apr = apr_conversion(lang_select, apr)
  loan_duration = loan_term(lang_select, loan_duration)
  monthly_payment = loan_amount * (apr / (1 - (1 + apr)**(-loan_duration[2])))
  result_screen(loan_amount, apr, loan_duration, monthly_payment)
  prompt(lang_select, 'redo')
  choice = gets.chomp.upcase
  if choice.start_with?('N')
    break
  end
end
prompt(lang_select, 'goodbye')
