require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  def setup
    @image = Image.find images(:rails).id
  end

  test 'find' do
    assert_kind_of Image, @image
    assert_equal images(:rails).name, @image.name
    assert_equal images(:rails).caption, @image.caption
    assert_equal images(:rails).image_file_name, @image.image_file_name
    assert_equal images(:rails).image_content_type, @image.image_content_type
    assert_equal images(:rails).image_file_size, @image.image_file_size
    assert_equal images(:rails).image_updated_at, @image.image_updated_at
  end

  test 'create' do
    file = Rack::Test::UploadedFile.new(
      File.join(Rails.root, 'test', 'fixtures', 'files', 'test.gif'),
      'image/gif'
    )
    assert_difference 'Image.count' do
      @image = Image.create(
        name: 'Help screenshot',
        caption: 'Help screen',
        image: file
      )
    end
  end

  test 'update' do
    assert_no_difference 'Image.count' do
      assert @image.update_attributes(name: 'Updated name')
    end

    assert_equal 'Updated name', @image.reload.name
  end

  test 'destroy' do
    assert_difference('Image.count', -1) { @image.destroy }
  end

  test 'validates blank attributes' do
    @image.name = '  '
    @image.caption = '  '
    @image.image = nil
    assert @image.invalid?
    assert_equal 3, @image.errors.count
    assert_equal [error_message_from_model(@image, :name, :blank)],
      @image.errors[:name]
    assert_equal [error_message_from_model(@image, :caption, :blank)],
      @image.errors[:caption]
    assert_equal [error_message_from_model(@image, :image, :blank)],
      @image.errors[:image]
  end

  test 'validates duplicated attributes' do
    @image.name = images(:ruby).name
    assert @image.invalid?
    assert_equal 1, @image.errors.count
    assert_equal [error_message_from_model(@image, :name, :taken)],
      @image.errors[:name]
  end

  test 'validates length of attributes' do
    @image.name = 'abcde' * 52
    @image.caption = 'abcde' * 52
    assert @image.invalid?
    assert_equal 2, @image.errors.count
    assert_equal [
      error_message_from_model(@image, :name, :too_long, count: 255)
    ], @image.errors[:name]
    assert_equal [
      error_message_from_model(@image, :caption, :too_long, count: 255)
    ], @image.errors[:caption]
  end
end
