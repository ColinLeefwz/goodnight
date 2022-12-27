class ClockedRecordSerializer < ActiveModel::Serializer
  attributes :id, :clocked_in, :slot_seconds, :status
  belongs_to :user, serializer: UserSerializer
end
