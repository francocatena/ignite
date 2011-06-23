require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  fixtures :lessons

  # Función para inicializar las variables utilizadas en las pruebas
  def setup
    @lesson = Lesson.find lessons(:introduction).id
  end

  # Prueba que se realicen las búsquedas como se espera
  test 'find' do
    assert_kind_of Lesson, @lesson
    assert_equal lessons(:introduction).name, @lesson.name
    assert_equal lessons(:introduction).sequence, @lesson.sequence
  end

  # Prueba la creación de una clase
  test 'create' do
    assert_difference 'Lesson.count' do
      @lesson = Lesson.create(
        :name => 'New name',
        :sequence => 4
      )
    end
  end

  # Prueba de actualización de una clase
  test 'update' do
    assert_no_difference 'Lesson.count' do
      assert @lesson.update_attributes(:name => 'Updated name'),
        @lesson.errors.full_messages.join('; ')
    end

    assert_equal 'Updated name', @lesson.reload.name
  end

  # Prueba de eliminación de clases
  test 'destroy' do
    assert_difference('Lesson.count', -1) { @lesson.destroy }
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates blank attributes' do
    @lesson.name = '  '
    @lesson.sequence = '  '
    assert @lesson.invalid?
    assert_equal 2, @lesson.errors.count
    assert_equal [error_message_from_model(@lesson, :name, :blank)],
      @lesson.errors[:name]
    assert_equal [error_message_from_model(@lesson, :sequence, :blank)],
      @lesson.errors[:sequence]
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates length of attributes' do
    @lesson.name = 'abcde' * 52
    assert @lesson.invalid?
    assert_equal 1, @lesson.errors.count
    assert_equal [error_message_from_model(@lesson, :name, :too_long,
      :count => 255)], @lesson.errors[:name]
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates formatted attributes' do
    @lesson.sequence = '1.z2'
    assert @lesson.invalid?
    assert_equal 1, @lesson.errors.count
    assert_equal [error_message_from_model(@lesson, :sequence, :not_a_number)],
      @lesson.errors[:sequence]

    @lesson.sequence = '-1'
    assert @lesson.invalid?
    assert_equal 1, @lesson.errors.count
    assert_equal [error_message_from_model(@lesson, :sequence, :greater_than,
        :count => 0)], @lesson.errors[:sequence]

    @lesson.reload
    @lesson.sequence = '1.2'
    assert @lesson.invalid?
    assert_equal 1, @lesson.errors.count
    assert_equal [error_message_from_model(@lesson, :sequence, :not_an_integer)],
      @lesson.errors[:sequence]
  end
end