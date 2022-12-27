class ClockedRecordSerializer < ActiveModel::Serializer
  attributes :id, :clocked_in, :slot_seconds, :status
end
