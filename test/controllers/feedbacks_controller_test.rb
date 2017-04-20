require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  setup do
    @feedback = feedbacks(:good)
    @lesson = @feedback.lesson
    @request.remote_addr = '127.0.0.1'
  end

  test 'should get index' do
    get :index, params: { lesson_id: @lesson.to_param }
    assert_response :success
    assert_not_nil assigns(:feedbacks)
    assert_template 'feedbacks/index'
  end

  test 'should get new' do
    get :new, params: { lesson_id: @lesson.to_param }
    assert_response :success
    assert_not_nil assigns(:feedback)
    assert_template 'feedbacks/new'
  end

  test 'should create feedback' do
    assert_difference('Feedback.count') do
      post :create, params: {
        lesson_id: @lesson.to_param,
        feedback: {
          rate: 3,
          comments: 'So so',
          lesson_id: lessons(:introduction).id
        }
      }
    end

    assert_redirected_to lesson_feedback_url(@lesson, assigns(:feedback))
    assert_equal @request.remote_addr, assigns(:feedback).ip
  end

  test 'should show feedback' do
    get :show, params: { lesson_id: @lesson.to_param, id: @feedback }
    assert_response :success
    assert_template 'feedbacks/show'
  end

  test 'should get edit' do
    get :edit, params: { lesson_id: @lesson.to_param, id: @feedback }
    assert_response :success
    assert_template 'feedbacks/edit'
  end

  test 'should update feedback' do
    assert_no_difference 'Feedback.count' do
      put :update, params: {
        lesson_id: @lesson.to_param,
        id: @feedback,
        feedback: {
          rate: 3,
          comments: 'Updated comments',
          lesson_id: lessons(:introduction).id
        }
      }
    end

    assert_redirected_to lesson_feedback_url(@lesson, assigns(:feedback))
    assert_equal 'Updated comments', @feedback.reload.comments
    assert_equal @request.remote_addr, assigns(:feedback).ip
  end

  test 'should destroy feedback' do
    @feedback = feedbacks(:local)
    @lesson = @feedback.lesson

    assert_difference 'Feedback.count', -1 do
			delete :destroy, params: {
				lesson_id: @lesson.to_param,
				id: @feedback.to_param
			}
    end

    assert_redirected_to lesson_feedbacks_url(@lesson)
  end
end
