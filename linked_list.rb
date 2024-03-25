# frozen string literal: true

# linked list class
class LinkedList
  attr_accessor :head, :size

  def initialize(node = nil)
    @head = (node if node.instance_of?(Node))
    @size = node.instance_of?(Node) ? 1 : 0
  end

  def append(value)
    inc_size
    if head.nil?
      @head = Node.new(value)
    else
      curr = head
      curr = curr.next until curr.next.nil?
      curr.next = Node.new(value)
    end
  end

  def prepend(value)
    inc_size
    aux = Node.new(value)
    aux.next = head
    @head = aux
  end

  def inc_size
    @size += 1
  end

  def tail
    curr = head
    curr = curr.next until curr.next.nil?
    curr
  end

  def at_index(idx)
    return puts 'Invalid index' if idx >= size

    curr_i = 0
    curr_node = head
    until curr_i == idx
      curr_node = curr_node.next
      curr_i += 1
    end
    curr_node
  end

  def pop
    return if size.zero?

    curr_node = head
    if curr_node.next.nil?
      curr_node.next = nil
    else
      curr_node = curr_node.next until curr_node.next.next.nil?
    end
    curr_node.next = nil
  end

  def contains?(value)
    !find(value).nil?
  end

  def find(value)
    idx = 0
    curr_node = head
    begin
      until curr_node.value == value
        curr_node = curr_node.next
        idx += 1
      end
    rescue StandardError
      idx = nil
    end
    idx
  end

  def to_s
    curr = head
    ans = ''
    until curr.nil?
      ans += "( #{curr.value} ) -> "
      curr = curr.next
    end
    ans += 'nil'
    ans
  end

  def insert_at(value, index)
    return puts "Max available index #{size}" if index > size
    return prepend(value) if index.zero? || size.zero?

    inc_size
    idx = 1
    curr = head
    until idx == index
      idx += 1
      curr = curr.next
    end
    node_to_move = curr.next
    curr.next = Node.new(value)
    curr.next.next = node_to_move
  end

  def remove_at(index)
    return puts "Max available index #{size}" if index >= size
    return pop if index == size

    if index.zero?
      @head = head.next
    else
      idx = 1
      curr = head
      until idx == index
        idx += 1
        curr = curr.next
      end
      curr.next = curr.next.next
    end
  end
end

class Node
  attr_accessor :value, :next

  def initialize(value = nil)
    @value = value
    @next = nil
  end
end
