require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  fixtures :slides

  # Función para inicializar las variables utilizadas en las pruebas
  def setup
    @slide = Slide.find slides(:opening).id
  end

  # Prueba que se realicen las búsquedas como se espera
  test 'find' do
    assert_kind_of Slide, @slide
    assert_equal slides(:opening).title, @slide.title
    assert_equal slides(:opening).number, @slide.number
  end

  # Prueba la creación de una diapositiva
  test 'create' do
    assert_difference 'Slide.count' do
      @slide = Slide.create(
        :title => 'New title',
        :number => 3
      )
    end
  end

  # Prueba de actualización de una diapositiva
  test 'update' do
    assert_no_difference 'Slide.count' do
      assert @slide.update_attributes(:title => 'Updated title'),
        @slide.errors.full_messages.join('; ')
    end

    assert_equal 'Updated title', @slide.reload.title
  end

  # Prueba de eliminación de diapositivas
  test 'destroy' do
    assert_difference('Slide.count', -1) { @slide.destroy }
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates blank attributes' do
    @slide.title = '  '
    @slide.number = '  '
    assert @slide.invalid?
    assert_equal 2, @slide.errors.count
    assert_equal [error_message_from_model(@slide, :title, :blank)],
      @slide.errors[:title]
    assert_equal [error_message_from_model(@slide, :number, :blank)],
      @slide.errors[:number]
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates length of attributes' do
    @slide.title = 'abcde' * 52
    assert @slide.invalid?
    assert_equal 1, @slide.errors.count
    assert_equal [error_message_from_model(@slide, :title, :too_long,
      :count => 255)], @slide.errors[:title]
  end

  # Prueba que las validaciones del modelo se cumplan como es esperado
  test 'validates formatted attributes' do
    @slide.number = '1.z2'
    assert @slide.invalid?
    assert_equal 1, @slide.errors.count
    assert_equal [error_message_from_model(@slide, :number, :not_a_number)],
      @slide.errors[:number]

    @slide.number = '-1'
    assert @slide.invalid?
    assert_equal 1, @slide.errors.count
    assert_equal [error_message_from_model(@slide, :number, :greater_than,
        :count => 0)], @slide.errors[:number]

    @slide.reload
    @slide.number = '1.2'
    assert @slide.invalid?
    assert_equal 1, @slide.errors.count
    assert_equal [error_message_from_model(@slide, :number, :not_an_integer)],
      @slide.errors[:number]
  end
end