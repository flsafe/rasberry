require 'spec_helper'
require 'yaml'

describe "grade_sheets/show.html.erb" do

  def tests
    {:test_string_length_one=>
      {:input=>'abc',
       :output=>'abc',
       :expected=>'abc',
       :points=>10,
       :error=>nil}}
  end

  before(:each) do
    view.stub(:current_user).and_return(stub_model(User))
    @grade_sheet =  assign(:grade_sheet, mock_model(GradeSheet,
      :user_id => stub_model(User).as_null_object,
      :exercise => stub_model(Exercise, :get_stat=>1).as_null_object,
      :grade => 1.5,
      :unit_tests=> tests(),
      :src_code => "MyText",
      :unit_tests_failed? => false,
      :lesson=>stub_model(Lesson, :title=>"title")).as_null_object)
  end

  it "uses the grade sheets unit tests" do
    @grade_sheet.should_receive(:unit_tests)
    render
  end

  it "should use the src code" do
    @grade_sheet.should_receive(:src_code)
    render
  end

  it "should use the grade" do
    @grade_sheet.should_receive(:grade)
    render
  end
end
