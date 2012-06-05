require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  setup do
    @feedback = feedbacks(:good)
    @request.remote_addr = '127.0.0.1'
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedbacks)
    assert_select '#error_body', false
    assert_template 'feedbacks/index'
  end
  
  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:feedback)
    assert_select '#error_body', false
    assert_template 'feedbacks/new'
  end

  test 'should create feedback' do
    assert_difference('Feedback.count') do
      post :create, feedback: {
        rate: 3,
        comments: 'So so',
        lesson_id: lessons(:introduction).id
      }
    end

    assert_redirected_to feedback_path(assigns(:feedback))
    assert_equal @request.remote_addr, assigns(:feedback).ip
  end

  test 'should show feedback' do
    get :show, id: @feedback
    assert_response :success
    assert_select '#error_body', false
    assert_template 'feedbacks/show'
  end

  test 'should get edit' do
    get :edit, id: @feedback
    assert_response :success
    assert_select '#error_body', false
    assert_template 'feedbacks/edit'
  end

  test 'should update feedback' do
    assert_no_difference 'Feedback.count' do
      put :update, id: @feedback, feedback: {
        rate: 3,
        comments: 'Updated comments',
        lesson_id: lessons(:introduction).id
      }
    end
    
    assert_redirected_to feedback_path(assigns(:feedback))
    assert_equal 'Updated comments', @feedback.reload.comments
    assert_equal @request.remote_addr, assigns(:feedback).ip
  end
  
  test 'should destroy feedback' do
    @feedback = feedbacks(:local)
    
    assert_difference 'Feedback.count', -1 do
      delete :destroy, id: @feedback.to_param
    end

    assert_redirected_to feedbacks_path
  end
end
