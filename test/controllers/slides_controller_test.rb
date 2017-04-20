require 'test_helper'

class SlidesControllerTest < ActionController::TestCase
  setup do
    @slide = slides(:opening)
    @lesson = lessons(:introduction)
    @request.remote_addr = '127.0.0.1'
  end

  test 'should get index' do
    get :index, params: { lesson_id: @lesson.to_param }
    assert_response :success
    assert_not_nil assigns(:slides)
    assert_template 'slides/index'
  end

  test 'should get new' do
    get :new, params: { lesson_id: @lesson.to_param }
    assert_response :success
    assert_template 'slides/new'
  end

  test 'should create slide' do
    assert_difference ['Slide.count', 'TextNode.count', 'CodeNode.count'] do
      post :create, params: {
        lesson_id: @lesson.to_param,
        slide: {
          title: 'New slide',
          number: '4',
          extra_classes: 'test-class',
          style: 'color: pink',
          nodes_attributes: [
            {
              type: 'TextNode',
              content: 'h1. Some sample title',
              rank: '1'
            }, {
              type: 'CodeNode',
              content: 'puts "Some Ruby code"',
              lang: 'ruby',
              rank: '2'
            }
          ]
        }
      }
    end

    assert_redirected_to course_lesson_path(@lesson.course, @lesson, anchor: assigns(:slide).anchor)
  end

  test 'should show slide' do
    get :show, params: { lesson_id: @lesson.to_param, id: @slide.to_param }
    assert_response :success
    assert_template 'slides/show'
  end

  test 'should get edit' do
    get :edit, params: { lesson_id: @lesson.to_param, id: @slide.to_param }
    assert_response :success
    assert_template 'slides/edit'
  end

  test 'should update slide' do
    assert_no_difference ['Slide.count', 'TextNode.count', 'CodeNode.count'] do
      put :update, params: {
        lesson_id: @lesson.to_param,
        id: @slide.to_param,
        slide: {
          title: 'Updated title',
          number: '1',
          extra_classes: 'test-class',
          style: 'color: pink',
          nodes_attributes: [
            {
              id: nodes(:opening_title).id,
              type: 'TextNode',
              content: 'h1. Updated sample title',
              rank: '1'
            }, {
              id: nodes(:opening_ruby_code).id,
              type: 'CodeNode',
              content: 'puts "Some Updated Ruby code"',
              lang: 'ruby',
              rank: '2'
            }
          ]
        }
      }
    end

    assert_redirected_to course_lesson_path(@lesson.course, @lesson, anchor: assigns(:slide).anchor)
    assert_equal 'Updated title', @slide.reload.title
    assert_equal 'h1. Updated sample title', @slide.text_nodes.first.content
  end

  test 'should destroy slide' do
    assert_difference 'Slide.count', -1 do
			delete :destroy, params: {
				lesson_id: @lesson.to_param,
				id: @slide.to_param
			}
    end

    assert_redirected_to lesson_slides_path(@lesson)
  end

  test 'execute ruby locally' do
    post :execute_ruby, xhr: true, params: {
      code_node: {
        code: 'puts "Inside a test!"'
      }
    }

    assert_match /Inside a test/, @response.body
  end

  test 'can not execute ruby from remote hosts' do
    @request.remote_addr = '192.168.0.1'
    post :execute_ruby, xhr: true, params: {
      code_node: {
        code: 'puts "Inside a test!"'
      }
    }

    assert_no_match /Inside a test/, @response.body
  end
end
