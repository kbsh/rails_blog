class Tasks::Onetime::CreateSearchIndex
  # Contentモデルのelasticsearchインデックスを作成します。
  def self.execute
    Content.create_index! force: true
    Content.import force: true
    p "created index!"
  end
end
