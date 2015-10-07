require 'spec_helper'
require 'debugger'

describe MoviesController do
  before :each do
	@fake_movie1 = mock('movie1',:movie_id=>111, :title=>'alien', :director=>'George Lucas')
	@fake_results = [@fake_movie1, mock('movie4',:movie_id=>114, :title=>'alien', :director=>'George Lucas')]
  end

  describe '#edit:' do
	it 'should call the model Movie to find' do
		Movie.should_receive(:find).with("111").and_return(@fake_movie1)
		post :edit, {:id=>"111"}
	end
	
	context 'after valid search' do
	   before :each do
		Movie.stub(:find).with("111").and_return(@fake_movie1)
		post :edit, {:id=>"111"}
	   end
	   it 'should select the edit Movie view template for rending' do
		    response.should render_template('edit')
	   end

	   it 'should make the same director search result aviable to the template' do
		    assigns(:movie).should == @fake_movie1
	   end
	end
  end

  describe '#destroy:' do
	it 'should call the model Movie to create' do
		Movie.should_receive(:find).with("111").and_return(@fake_movie1)
		@fake_movie1.should_receive(:destroy)
		post :destroy, {:id=>"111"}
	end

	context 'after valid search' do
	   before :each do
		Movie.stub(:find).with("111").and_return(@fake_movie1)
		@fake_movie1.stub(:destroy)
		post :destroy, {:id=>"111"}
	   end

	   it 'should redirect to home page' do
	      response.should redirect_to(movies_path)
	   end

     	   it 'should make the same director search result aviable to the template' do
	       assigns(:movie).should == @fake_movie1
     	   end
	end
  end

  describe '#similar:' do
     it 'should call the model Movies method to find the movies with director' do
	Movie.should_receive(:find).with("111").and_return(@fake_movie1)
	Movie.should_receive(:find_all_by_director).with("George Lucas").and_return(@fake_results)
	get :similar, {:movie_id=>"111"}
     end

     describe 'after valid search:' do
	before :each do
	    Movie.stub(:find).with("111").and_return(@fake_movie1)
	    Movie.stub(:find_all_by_director).with("George Lucas").and_return(@fake_results)
	    get :similar, {:movie_id=>"111"}
	end
     	it 'should select the Show Movie view template for rending' do
	    response.should render_template('similar')
     	end

     	it 'should make the same director search result aviable to the template' do
	    assigns(:similar_movies).should == @fake_results
     	end


     	it 'should make movie title aviable to the template' do
	    assigns(:movie).should == @fake_movie1
     	end

     end

     describe 'do not know the director:' do
	before :each do
	    @fake_movie2=mock('movie2',:id=>112, :title=>'alien', :director=>"")
	    Movie.stub(:find).with("112").and_return(@fake_movie2)
	    get :similar, {:movie_id=>112}
	end

	it 'should redirect to home page' do
	    response.should redirect_to(movies_path)
	end

    	it 'should flash notes when the movie has no director info' do
	    flash[:notice].should =~ /'alien' has no director info/
    	end
     end
  end
end
