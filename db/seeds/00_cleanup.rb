# Remove records and Active Storage data so the complete seed is repeatable.
# This file is loaded first by db/seeds.rb; run it directly only when a reset is intended.
ActiveStorage::Attachment.destroy_all
ActiveStorage::VariantRecord.destroy_all
ActiveStorage::Blob.destroy_all
User.destroy_all
