
gr_key=ENV["GOODREADS_KEY"] 

client = Goodreads.new(:api_key => gr_key)

@search = client.search_books('The Lord Of The Rings')
	search.results.work.each do |book|
	  book.id        
	  book.title     
	end




