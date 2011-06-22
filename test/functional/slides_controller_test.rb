require 'test_helper'

class SlidesControllerTest < ActionController::TestCase
  setup do
    @slide = slides(:opening)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:slides)
    assert_select '#error_body', false
    assert_template 'slides/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_select '#error_body', false
    assert_template 'slides/new'
  end

  test 'should create slide' do
    assert_difference 'Slide.count' do
      post :create, :slide => {
        :title => 'New slide',
        :number => '3'
      }
    end

    assert_redirected_to slide_path(assigns(:slide))
  end

  test 'should show slide' do
    get :show, :id => @slide.to_param
    assert_response :success
    assert_select '#error_body', false
    assert_template 'slides/show'
  end

  test 'should get edit' do
    get :edit, :id => @slide.to_param
    assert_response :success
    assert_select '#error_body', false
    assert_template 'slides/edit'
  end

  test 'should update slide' do
    assert_no_difference 'Slide.count' do
      put :update, :id => @slide.to_param, :slide => {
        :title => 'Updated title',
        :number => '1'
      }
    end
    
    assert_redirected_to slide_path(assigns(:slide))
    assert_equal 'Updated title', @slide.reload.title
  end

  test 'should destroy slide' do
    assert_difference 'Slide.count', -1 do
      delete :destroy, :id => @slide.to_param
    end

    assert_redirected_to slides_path
  end
end