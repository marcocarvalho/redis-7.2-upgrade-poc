@value_size = 1024  # 1KB
@num_keys = 10_000

# from: https://redis.io/docs/manual/patterns/bulk-loading/
def gen_redis_proto(*cmd)
  proto = ""
  proto << "*"+cmd.length.to_s+"\r\n"
  cmd.each{|arg|
      proto << "$"+arg.to_s.bytesize.to_s+"\r\n"
      proto << arg.to_s+"\r\n"
  }
  proto
end

def sample_data
  @sample_data ||= ('a'..'z').to_a * 39
end

def random_string
  sample_data.sample(rand(100..@value_size)).join
end

def generate_n_keys(number)
  (1..number).map { |i| "k_#{i}_#{sample_data.sample(rand(1..100)).join}" }
end

def expand(command)
  command.map { |item| item.respond_to?(:call) ? item.call : item }.flatten
end

commands = [
  ["SET", ->() { random_string }, ->() { random_string }],
  ["HSET", ->() { generate_n_keys(1) }, ->() { arr = generate_n_keys(rand(100)) ; arr.zip(arr.size.times.map { random_string }).flatten }],
  ["LPUSH", ->() { random_string }, ->() { rand(10..@value_size).times.map { random_string } }],
  ["ZADD", ->() { random_string }, ->() { rand(10..@value_size).times.map { [ rand(@value_size), random_string ] }.flatten }],
]

@num_keys.times do |i|
  command = commands.sample
  puts gen_redis_proto(*expand(command))
end