require 'kpcc/client'

module Kpcc
  class Article

    class << self
      def find(obj_key)
        response = client.get("articles/#{obj_key}")

        if response.success?
          new(response.body)
        else
          raise ActiveRecord::RecordNotFound
        end
      end

      #-----------------

      def find_by_url(url)
        response = client.get("articles/by_url", url: url)

        if response.success?
          new(response.body)
        else
          nil
        end
      end

      #-----------------

      def most_viewed
        response = client.get("articles/most_viewed")

        if response.success?
          articles = []

          Array(response.body).each do |article_json|
            articles << new(article_json)
          end

          articles

        else
          nil
        end
      end

      #-----------------

      private

      def client
        @client ||= Kpcc::Client.new
      end
    end




    ATTRIBUTES = [
      :id,
      :title,
      :short_title,
      :teaser,
      :body,
      :published_at,
      :thumbnail,
      :byline,
      :public_url
    ]

    attr_accessor *ATTRIBUTES

    def initialize(attributes={})
      @id           = attributes["id"]
      @title        = attributes["title"]
      @short_title  = attributes["short_title"]
      @teaser       = attributes["teaser"]
      @body         = attributes["body"]
      @thumbnail    = attributes["thumbnail"]
      @byline       = attributes["byline"]
      @public_url   = attributes["public_url"]
      @published_at = Time.parse(attributes["published_at"].to_s)
    end

    # Steal the ActiveRecord behavior for object comparison.
    # If they're the same class and the ID is the same, then it's "same"
    # enough for us.
    def ==(comparison_object)
      super ||
        comparison_object.instance_of?(Kpcc::Article) &&
        self.id.present? &&
        self.id == comparison_object.id
    end
    alias :eql? :==

  end
end
