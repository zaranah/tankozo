class Genre < ActiveHash::Base
  self.data = [
    { id: 2, name: '寿司' },
    { id: 3, name: '魚介・海鮮料理' },
    { id: 4, name: '揚げ物' },
    { id: 5, name: '和食麺類' },
    { id: 6, name: '鍋' },
    { id: 7, name: '粉物' },
    { id: 8, name: '丼' },
    { id: 9, name: 'ステーキ・ハンバーグ・鉄板焼き' },
    { id: 10, name: '焼肉' },
    { id: 11, name: 'イタリアン' },
    { id: 12, name: 'フレンチ' },
    { id: 13, name: 'スペイン料理' },
    { id: 14, name: '中華料理' },
    { id: 15, name: '韓国料理' },
    { id: 16, name: '東南アジア料理' },
    { id: 17, name: 'その他' }
  ]

  include ActiveHash::Associations
  has_many :restaurants
end
