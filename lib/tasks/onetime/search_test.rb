class Tasks::Onetime::SearchTest
  # Contentモデルの検索テストです。
  def self.execute()
    contents = Content.search(
      {
        query: {
          bool: {
            must: [
              query_string: {
                default_field: "title",
                query: "ec2 AND サーバー"
              }
            ],
            filter: [
            ],
            should: [
            ],
            must_not: [
              query_string: {
                default_field: "title",
                #query: "ubuntu OR ディスク"
                query: ""
              }
            ]
          }
        },
        from: 0,
        size: 100
      }
    )

    contents.each do |a|
      p a.title + " : " + a.filename
    end
  end
end
