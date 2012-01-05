require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  fixtures :courses

  # Función para inicializar las variables utilizadas en las pruebas
  def setup
    @course = Course.find courses(:ignite)
  end

  # Prueba que se realicen las búsquedas como se espera
  test 'find' do
    assert_kind_of Course, @course
    assert_equal courses(:ignite).name, @course.name
    assert_equal courses(:ignite).notes, @course.notes
  end

  # Prueba la creación de un curso
  test 'create' do
    assert_difference 'Course.count' do
      @course = Course.create(
        name: 'New name',
        notes: 'New notes'
      )
    end
  end

  # Prueba de actualización de un curso
  test 'update' do
    assert_no_difference 'Course.count' do
      assert @course.update_attributes(name: 'Updated name'),
        @course.errors.full_messages.join('; ')
    end

    assert_equal 'Updated name', @course.reload.name
  end

  # Prueba de eliminación de cursos
  test 'destroy' do
    assert_difference('Course.count', -1) { @course.destroy }
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates blank attributes' do
    @course.name = '  '
    assert @course.invalid?
    assert_equal 1, @course.errors.count
    assert_equal [error_message_from_model(@course, :name, :blank)],
      @course.errors[:name]
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates length of attributes' do
    @course.name = 'abcde' * 52
    assert @course.invalid?
    assert_equal 1, @course.errors.count
    assert_equal [
      error_message_from_model(@course, :name, :too_long, count: 255)
    ], @course.errors[:name]
  end
  
  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates uniqueness of attributes' do
    @course.name = courses(:torch).name
    assert @course.invalid?
    assert_equal 1, @course.errors.count
    assert_equal [error_message_from_model(@course, :name, :taken)],
      @course.errors[:name]
  end
end