

class Node

    attr_accessor :left, :right, :data

    def initialize(data, left=nil, right=nil)
        @data = data
        @left = left
        @right = right
    end

    def ==(other)
        self.data == other.data
    end

    def >(other)
        self.data > other.data
    end

    def <(other)
        self.data < other.data
    end

end

class Tree

    attr_accessor :root, :data

    def initialize(array)
        @data = array.sort.uniq
        @root = build_tree(data)
        
    end

    def build_tree(array, s_tart = 0, e_nd = array.length - 1)
        
        return nil if s_tart > e_nd
        
        
        middle = (s_tart + e_nd)  / 2
        
        root = Node.new(array[middle])
        root.left = build_tree(array,s_tart, middle - 1)
        root.right = build_tree(array, middle + 1, e_nd)

        return root
    end

   
    def insert(node = root, value)
        
        return nil if value == node.data      

        if value < node.data
            node.left.nil? ? node.left = Node.new(value) : insert(node.left, value)
        elsif value > node.data
            node.right.nil? ? node.right = Node.new(value) : insert(node.right, value)
        end       

    end

    def delete(node = root, value)
        if node.nil?
            return node
        end

        if value < node.data
            node.left = delete(node.left, value)

        elsif value > node.data
            node.right = delete(node.right, value)

        else
            if node.left.nil?
                temp = node.right
                node = nil
                return temp
            elsif node.right.nil?
                temp = node.left
                node = nil
                return temp                
            end

            temp = min_value_node(node.right)

            node.data = temp.data

            node.right = delete(node.right, temp.data)
        end

        return node

    end

    def min_value_node(node)
        current = node

        while !current.left.nil? 
            current = current.left
        end

        return current
    end

    

    def find(value, node = root)

        return node if node.nil? || node.data == value             

        value < node.data ? find(value, node.left) : node = find(value, node.right)

        
    end

    def level_order(node = root, queue = [])
             
        print "#{node.data}"
        queue << node.left unless node.left.nil?
        queue << node.right unless node.right.nil?
        
        return if queue.empty?
        
        level_order(queue.shift, queu)
        

    end

    def in_order(node = root)
        
        return if node.nil?

        in_order(node.left) 
        print "#{node.data} "
        in_order(node.right)         
                
    end

    def pre_order(node = root)
        
        return if node.nil?
        
        print "#{node.data} "
        pre_order(node.left)
        pre_order(node.right)

    end

    def post_order(node = root)
        
        return if node.nil?
        
        post_order(node.left)
        post_order(node.right)
        print "#{node.data} "
        
    end

    def height(node = root)
        unless node.nil? || node == root
            node = (node.instance_of?(Node) ? find(node.data) : find(node))
        end

        return -1 if node.nil?
        [height(node.left), height(node.right)].max + 1
    end

    def depth(node = root, parent = root, edges = 0)
        return 0 if node == parent
        return -1 if parent.nil?
        
        if node < parent.data
            edges += 1
            depth(node, parent.left, edges)
        elsif node > parent.data
            edges += 1
            depth(node, parent.right, edges)
        else
            edges
        end
    end

    def balanced?(node = root)
        return true if node.nil?
        left_height = height(node.left)
        right_height = height(node.right)

        return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

        false
    end

    def rebalance
        self.data = inorder_array
        self.root = build_tree(data)
    end

    def pretty_print(node = root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    def inorder_array(node = root, array = [])
        unless node.nil?
            inorder_array(node.left, array)
            array << node.data
            inorder_array(node.right, array)
        end
        array
    end
end



tree = Tree.new((Array.new(15) { rand(1..100) }))

puts "It is #{tree.balanced?} that this binary tree is balanced" 

puts "Printing preorder"
puts tree.pre_order

puts "Printing inorder"
puts tree.in_order

puts "Printing postorder"
puts tree.post_order

puts "Adding three numbers higher than 100"
tree.insert(150)
tree.insert(125)
tree.insert(250)

puts "It is #{tree.balanced?} that this binary tree is balanced" 

puts "Rebalancing tree now"
tree.rebalance

puts "It is #{tree.balanced?} that this binary tree is balanced" 

puts "Printing preorder"
puts tree.pre_order


puts "Printing inorder"
puts tree.in_order


puts "Printing postorder"
puts tree.post_order


tree.pretty_print

