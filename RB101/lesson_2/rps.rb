VALID_CHOICES = { 'rock' => '', 'paper' => '', 'scissors' => '' }

def prompt(message)
  puts "=> #{message}"
end

def match_ups(p1, cpu)
  case [p1, cpu]
  when ['rock', 'scissors'], ['scissors', 'rock']
    VALID_CHOICES['rock'] << '1'
  when ['paper', 'rock'], ['rock', 'paper']
    VALID_CHOICES['paper'] << '1'
  when ['scissors', 'paper'], ['paper', 'scissors']
    VALID_CHOICES['scissors'] << '1'
  else
    VALID_CHOICES
  end
end

def display_winner(p1, cpu)
  if VALID_CHOICES[p1].to_i > VALID_CHOICES[cpu].to_i
    prompt("#{p1.capitalize} beats #{cpu.capitalize}, P1 wins!")
  elsif VALID_CHOICES[p1].to_i < VALID_CHOICES[cpu].to_i
    prompt("#{p1.capitalize} loses to #{cpu.capitalize}, CPU wins!")
  else
    prompt("#{p1.capitalize} vs #{cpu.capitalize}, is a draw!!")
  end
end

def set_score_number
  points = nil
  loop do
    points = gets.chomp.to_i
    break unless points.to_i <= 0
    prompt("Please select a number greater than 0")
  end
  points
end

def display_highest_score(scores)
  prompt("Player: #{scores[:player]}, Com: #{scores[:com]}")
  if scores[:player] > scores[:com]
    prompt("P! wins the game!!")
  else
    prompt("CPU wins the game!!")
  end
end


def interprate_player_choice(p1)
  if p1.start_with?('r')
    p1.replace(VALID_CHOICES.keys[0])
  elsif p1.start_with?('p')
    p1.replace(VALID_CHOICES.keys[1])
  elsif p1.start_with?('s')
    p1.replace(VALID_CHOICES.keys[2])
  else
    p1
  end
end

# def interprate_player_choice(p1)
#   case p1
#   when 'r'
#     p1.replace(VALID_CHOICES.keys[0])
#   when 'p'
#     p1.replace(VALID_CHOICES.keys[1])
#   when 's'
#     p1.replace(VALID_CHOICES.keys[2])
#   end
# end


scoreboard = { player: 0, com: 0 }

loop do # game loop

  scoreboard.each { |name, _| scoreboard[name] = 0 }
  
  prompt("How many points to play up to?")
  point_counter = set_score_number

  until (scoreboard[:player] == point_counter) || (scoreboard[:com] == point_counter)
  
    VALID_CHOICES.each { |k, _| VALID_CHOICES[k] = '0' }
    
    prompt("Player: #{scoreboard[:player]}, Com: #{scoreboard[:com]}")
    
    choice = ''
    prompt("Choose one: #{VALID_CHOICES.keys.join(', ')}")
    loop do # p1 loop
      choice = gets.chomp.downcase
      interprate_player_choice(choice)
      p choice
      
      if VALID_CHOICES.keys.include?(choice)
        break
      else
        prompt("Select either: #{VALID_CHOICES.keys.join(', ')} ")
      end
    end
    
    cpu_choice = VALID_CHOICES.keys.sample
    match_ups(choice, cpu_choice)
    
    display_winner(choice, cpu_choice)
    
    scoreboard.each do |name, _|
      if name == :player
        scoreboard[name] += VALID_CHOICES[choice].to_i
      else
        scoreboard[name] += VALID_CHOICES[cpu_choice].to_i
      end
    end
    
  end # until loop ends hear
  
  
  display_highest_score(scoreboard)

  prompt("Play again?(y/n)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt("Thanks for playing, goodbye :)")
