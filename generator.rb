require './chars'

WIDTH = 15
HEIGHT = 5
DOG_PROBABILITY = 0.6
DOG_DECORATED_PROBABILITY = 0.5
DOG_RUNNING_PROBABILITY = 0.3
DENSITY = 0.9

def mid_favoring_random(max)
    running_total = 0
    rolls = 3
    rolls.times do
        running_total += rand(max)
    end
    mean = (running_total.to_f / rolls).round().to_i
    return mean
end

def lower(a, b)
    return (a < b) ? a : b
end

def low_favoring_random(max)
    a = rand(max)
    b = rand(max)
    return lower(a, b)
end

def higher(a, b)
    return (a > b) ? a : b
end

def high_favoring_random(max)
    a = rand(max)
    b = rand(max)
    return higher(a, b)
end

def divide(total, num=5, min_size=4)
  chunks = []
  (num - 1).times do |i|
    max_size = ceil(total / (num - chunks.length))
    new_size = rand(max_size - min_size) + min_size
    total -= new_size
    chunks << new_size
  end
  chunks.append(total)
  return chunks
end

def generate()
    # For each dog line, choose a random number of dog,
    # then random small whitespace in front of some.
    line_count = HEIGHT
    # 2d array of strings
    lines = []
    previous_emoji_count = 0
    line_count.times do
        line = []

        # Lines should tend to have similar emoji densities.
        # Tweak constant to control crowdedness.
        max_per_line = rand((WIDTH * DENSITY / 2).round()) + 1
        emoji_count = mid_favoring_random(max_per_line)

        width_remaining = WIDTH
        emoji_count.times do
          width_remaining -= 1
          if rand() < DOG_PROBABILITY then
            object = Chars::DOGS.sample
            if rand() < DOG_DECORATED_PROBABILITY then
              dog_decorator = Chars::DOG_DECORATORS.sample
              width_remaining -= 1
              if Chars::UNALIGNED_DOGS.include? object then
                object = object + dog_decorator
              else
                object = dog_decorator + object
                if rand() < DOG_RUNNING_PROBABILITY then
                  width_remaining -= 1
                  object += Chars::DOG_DUST.sample
                end
              end
            end
          else
            object = Chars::ENVIRONMENT_DECORATORS.sample
          end
          line << object
        end
        width_remaining.times do
            line << Chars::IDEOGRAPHIC_SPACE
        end
        line.shuffle!
        lines << line
        previous_emoji_count = emoji_count
    end

    string = Chars::FENCE_TOP_LEFT + (Chars::FENCE_HORIZONTAL * (2 * WIDTH)) + Chars::FENCE_TOP_RIGHT + "\n"
    string << lines.collect { |line| Chars::FENCE_VERTICAL + line.join("") + Chars::FENCE_VERTICAL }.join("\n")
    string << "\n" + Chars::FENCE_BOTTOM_LEFT + (Chars::FENCE_HORIZONTAL * (2 * WIDTH)) + Chars::FENCE_BOTTOM_RIGHT
    return string
end
