# frozen string literal = true
require 'pry'

module StringHash
  def hash(key)
    hash_code = 0
    prime_number = 1_070_777_777

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code % @size
  end
end

class HashMap
  attr_reader :length
  attr_accessor :buckets

  include StringHash
  def initialize
    @length = 0
    @size = 16
    @load_factor = 0.75
    @buckets = Array.new(16)
  end

  def entries
    all_entries = @buckets.reject(&:nil?)
    all_entries.flatten(1)
  end

  def set(key, value)
    index = hash(key)
    set_at_index(index, key, value)
  end

  def get(key)
    index = hash(key)
    entry = @buckets[index]
    entry&.find { |pair| pair[0] == key }&.[](1)
  end

  def has(key)
    !get(key).nil?
  end

  def remove(key)
    index = hash(key)
    entry = @buckets[index]
    value = nil
    return if entry.nil?

    binding.pry
    entry&.each_with_index do |e, i|
      next unless e[0] == key || e == key

      @length -= 1
      value = e[1].nil? ? key : e[1]
      @buckets[index].delete_at(i)
      break
    end
    @buckets[index] = nil if @buckets[index] == []
    value
  end

  def clear
    @buckets = Array.new(@size, nil)
  end

  def keys
    entries.map { |pair| pair[0] }
  end

  def values
    entries.map { |pair| pair[1] }
  end

  private

  def check_load_factor
    return unless @length / @size.to_f > @load_factor

    grow_buckets
  end

  def grow_buckets
    all_entries = entries
    @size *= 2
    clear
    all_entries.each { |pair| set(pair[0], pair[1]) }
  end

  def place_key_value(arr, key, value)
    idx = nil
    arr.each_with_index do |pair, index|
      case pair
      in [key, *]
        idx = index
        break
      end
    end
    if idx.nil?
      arr << [key, value]
    else
      arr[idx][1] = value
    end
  end

  def set_at_index(index, key, value)
    raise IndexError if index.negative? || index >= @size

    @length += 1
    check_load_factor
    if @buckets[index].nil?
      @buckets[index] = [[key, value]]
    else
      place_key_value(@buckets[index], key, value)
    end
  end
end

class HashSet < HashMap
  def keys
    entries
  end

  def get(key)
    index = hash(key)
    entry = @buckets[index]
    entry&.find { |e| e == key }
  end

  def set(key)
    index = hash(key)
    set_at_index(index, key)
  end

  private

  def grow_buckets
    all_entries = keys
    @size *= 2
    clear
    all_entries.each { |e| set(e) }
  end

  def place_key_value(arr, key)
    idx = nil
    arr.each_with_index do |curr_key, index|
      if curr_key == key
        idx = index
        break
      end
    end
    if idx.nil?
      arr << [key, value]
    else
      arr[idx] = value
    end
  end

  def set_at_index(index, key)
    raise IndexError if index.negative? || index >= @size

    @length += 1
    check_load_factor
    return unless @buckets[index].nil?

    @buckets[index] = [key]
    edef test(arr)
    arr[2] = [2, 3]
    endlse
    place_key_value(@buckets[index], key)
  end
end

hs = HashSet.new
hs.set('pepe')
hs.set('pepes')
p hs.keys
p hs.remove('pepe')
p hs.entries
