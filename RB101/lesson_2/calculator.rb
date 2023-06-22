require 'yaml'
MESSAGES = YAML.load_file("calculator_messages.yml")
LANGUAGE = 'en'


def messages(message)
  MESSAGES[LANGUAGE][message]
end

def prompt(string)
  message = messages(string)
  puts "=> #{message}"
end

def perform_operation(number1, number2, operator)
  case operator
  when '1'
    result = number1 + number2
  when '2'
    result = number1 - number2
  when '3'
    result = number1 * number2
  when '4'
    result = number1 / number2.to_f
  end
  result
end

def valid_num?(number)
  loop do
    number = gets.chomp
    if number == number.to_i.to_s || number == number.to_f.to_s
      break
    else
      prompt('invalid_num')
    end
  end
  float_or_integer?(number)
end

def float_or_integer?(valid_number)
  if valid_number.to_f == valid_number.to_i
    valid_number.to_i
  else
    valid_number.to_f
  end
end

def operation_selection(operation, number2)
  loop do
    operation = gets.chomp
    if %w(1 2 3 4).include?(operation)
      if operation == '4' && number2.zero?
        prompt('zero_div_error')
        next
      end
      break
    else
      prompt('choose_operator_error')
    end
  end
  operation
end

def result_screen(number1, number2, operator, result)
  case operator
  when '1'
    "#{number1} + #{number2} = #{result}"
  when '2'
    "#{number1} - #{number2} = #{result}"
  when '3'
    "#{number1} * #{number2} = #{result}"
  when '4'
    "#{number1}/#{number2} = #{result}"
  end
end

prompt('welcome')

loop do
  prompt('number1')

  number1 = valid_num?(number1)

  prompt('number2') 
  number2 = valid_num?(number2)

  prompt('operator_prompt')
  operator = operation_selection(operator, number2)

  puts result_screen(number1, number2, operator, perform_operation(number1, number2, operator))

  prompt('redo')
  choice = gets.chomp.upcase
  if choice.start_with?('N')
    break
  end
end

prompt('goodbye')
