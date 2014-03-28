require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
  fixtures :feedbacks

  def setup
    @feedback = Feedback.find feedbacks(:good)
  end

  test 'find' do
    assert_kind_of Feedback, @feedback
    assert_equal feedbacks(:good).rate, @feedback.rate
    assert_equal feedbacks(:good).ip, @feedback.ip
    assert_equal feedbacks(:good).comments, @feedback.comments
    assert_equal feedbacks(:good).lesson_id, @feedback.lesson_id
  end

  test 'create' do
    assert_difference 'Feedback.count' do
      @feedback = Feedback.create(
        rate: 3,
        ip: '192.168.10.55',
        comments: 'So so',
        lesson_id: lessons(:introduction).id
      )
    end
  end

  test 'update' do
    assert_no_difference 'Feedback.count' do
      assert @feedback.update_attributes(comments: 'Updated comments'),
        @feedback.errors.full_messages.join('; ')
    end

    assert_equal 'Updated comments', @feedback.reload.comments
  end

  test 'destroy' do
    @feedback = feedbacks(:local)

    assert_difference('Feedback.count', -1) { @feedback.destroy }
  end

  test 'can not destroy remote feedback' do
    assert_no_difference('Feedback.count') { @feedback.destroy }
  end

  test 'validates blank attributes' do
    @feedback.rate = nil
    assert @feedback.invalid?
    assert_equal 2, @feedback.errors.count
    assert_equal [
      error_message_from_model(@feedback, :rate, :blank),
      error_message_from_model(@feedback, :rate, :inclusion)
    ].sort, @feedback.errors[:rate].sort
  end

  test 'validates included attributes' do
    @feedback.rate = 6
    assert @feedback.invalid?
    assert_equal 1, @feedback.errors.count
    assert_equal [error_message_from_model(@feedback, :rate, :inclusion)],
      @feedback.errors[:rate]
  end

  test 'validates uniqueness of attributes' do
    @feedback.ip = feedbacks(:bad).ip
    assert @feedback.invalid?
    assert_equal 1, @feedback.errors.count
    assert_equal [error_message_from_model(@feedback, :ip, :taken)],
      @feedback.errors[:ip]
  end
end
