module Post::Operation
  class Index < Trailblazer::Operation
    step :find_all

    def find_all(ctx, **)
      @posts = Post.all.reverse_order.page ctx[:params][:page]

      if ctx[:params][:type]
        if ctx[:params][:type] == 'own'
          @posts = @posts.where(user_id: ctx[:params][:user_id])
        elsif ctx[:params][:type] == 'other'
          @posts = @posts.where.not(user_id: ctx[:params][:user_id])
        end
      end

      if ctx[:params][:search] && ctx[:params][:search] != ''
        posts_by_title = @posts.where('title like ?', "%#{ctx[:params][:search]}%")
        @posts = posts_by_title.or(@posts.where('content like ?', "%#{ctx[:params][:search]}%"))
      end
      ctx[:model] = @posts
    end
  end
end
