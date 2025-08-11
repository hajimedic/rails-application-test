class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, presence: { message: "タイトルを入力してください" }, length: { maximum: 30, message: "タイトルは30文字以内で入力してください" }
  validate :image_must_be_attached

  private

  def image_must_be_attached
    errors.add(:image, "画像ファイルを選択してください") unless image.attached?
  end
end
