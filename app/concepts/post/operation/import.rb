require 'csv'
module Post::Operation
  class Import < Trailblazer::Operation
    step Contract::Build(constant: Post::Contract::Import)
    step Contract::Validate()
    step :import_csv!

    def import_csv!(_options, params:, **)
      file = File.open(params[:file])
      csv = CSV.parse(file, headers: true)

      if csv.count == 0 || csv['title'].include?(nil) || csv['content'].include?(nil) || csv['category_id'].include?(nil) || csv['user_id'].include?(nil)
        return false
      end


      csv.each do |row|
        post_hash = {}
        post_hash[:title] = row['title']
        post_hash[:content] = row['content']
        post_hash[:category_id] = row['category_id']
        post_hash[:user_id] = row['user_id']
        post_hash[:image] = File.open(Rails.root.join('app', 'assets', 'images', 'default-image.jpg'))
        Post.create(post_hash)
      end
    end
  end
end
