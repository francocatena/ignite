require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  fixtures :nodes

  # Función para inicializar las variables utilizadas en las pruebas
  def setup
    @node = Node.find nodes(:title).id
  end

  # Prueba que se realicen las búsquedas como se espera
  test 'find' do
    assert_kind_of Node, @node
    assert_equal nodes(:title).content, @node.content
    assert_equal nodes(:title).rank, @node.rank
  end

  # Prueba la creación de un nodo
  test 'create generic node' do
    assert_difference 'Node.count' do
      @node = Node.create(
        :content => 'New content',
        :rank => 3
      )
    end
  end
  
  # Prueba la creación de un nodo de texto
  test 'create text node' do
    assert_difference 'TextNode.count' do
      @node = TextNode.create(
        :content => 'New text content',
        :rank => 3
      )
    end
    
    assert @node.draw
  end
  
  # Prueba la creación de un nodo de código
  test 'create code node' do
    assert_difference 'CodeNode.count' do
      @node = CodeNode.create(
        :content => 'puts "Hello world!"',
        :rank => 3,
        :options => { 'lang' => 'ruby' }
      )
    end
    
    assert @node.draw
  end

  # Prueba de actualización de un nodo
  test 'update' do
    assert_no_difference 'Node.count' do
      assert @node.update_attributes(:content => 'Updated content'),
        @node.errors.full_messages.join('; ')
    end

    assert_equal 'Updated content', @node.reload.content
  end

  # Prueba de eliminación de nodos
  test 'destroy' do
    assert_difference('Node.count', -1) { @node.destroy }
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates blank attributes' do
    @node.content = '  '
    @node.rank = '  '
    assert @node.invalid?
    assert_equal 2, @node.errors.count
    assert_equal [error_message_from_model(@node, :content, :blank)],
      @node.errors[:content]
    assert_equal [error_message_from_model(@node, :rank, :blank)],
      @node.errors[:rank]
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates formatted attributes' do
    @node.rank = '1.z2'
    assert @node.invalid?
    assert_equal 1, @node.errors.count
    assert_equal [error_message_from_model(@node, :rank, :not_a_number)],
      @node.errors[:rank]

    @node.rank = '-1'
    assert @node.invalid?
    assert_equal 1, @node.errors.count
    assert_equal [error_message_from_model(@node, :rank, :greater_than,
        :count => 0)], @node.errors[:rank]

    @node.reload
    @node.rank = '1.2'
    assert @node.invalid?
    assert_equal 1, @node.errors.count
    assert_equal [error_message_from_model(@node, :rank, :not_an_integer)],
      @node.errors[:rank]
  end
  
  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates options' do
    @node = CodeNode.find nodes(:ruby_code).id
    @node.options['lang'] = 'not_supported'
    
    assert @node.invalid?
    assert_equal 1, @node.errors.count
    assert_equal [error_message_from_model(@node, :options, :invalid)],
      @node.errors[:options]
    
    @node.options['lang'] = nil
    
    assert @node.invalid?
    assert_equal 1, @node.errors.count
    assert_equal [error_message_from_model(@node, :options, :invalid)],
      @node.errors[:options]
    
    @node.options['lang'] = 'ruby'
    
    assert @node.valid?
  end
end