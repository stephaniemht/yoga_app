namespace :active_storage do
  desc "Copy blobs from one service to another and switch blob.service_name"
  task migrate_service: :environment do
    from_service = ENV.fetch("FROM_SERVICE", "cloudinary")
    to_service = ENV.fetch("TO_SERVICE") do
      abort "Missing TO_SERVICE. Example: TO_SERVICE=amazon"
    end

    dry_run = ActiveModel::Type::Boolean.new.cast(ENV["DRY_RUN"])
    limit = ENV["LIMIT"]&.to_i
    batch_size = (ENV["BATCH_SIZE"] || 100).to_i

    services = ActiveStorage::Blob.services
    begin
      services.fetch(from_service)
    rescue KeyError
      abort "Unknown FROM_SERVICE: #{from_service}"
    end

    target = services.fetch(to_service) { abort "Unknown TO_SERVICE: #{to_service}" }

    scope = ActiveStorage::Blob.where(service_name: from_service)
    scope = scope.limit(limit) if limit&.positive?
    total = scope.count

    puts "Migrating #{total} blob(s) from #{from_service} to #{to_service} (dry_run=#{dry_run})"

    processed = 0
    migrated = 0
    skipped = 0
    failed = []

    scope.find_in_batches(batch_size: batch_size) do |batch|
      batch.each do |blob|
        processed += 1
        begin
          if target.exist?(blob.key)
            skipped += 1
          else
            unless dry_run
              upload_options = {}
              upload_options[:checksum] = blob.checksum if blob.checksum.present?

              blob.open do |io|
                target.upload(blob.key, io, **upload_options)
              end
            end
          end

          blob.update_columns(service_name: to_service) unless dry_run
          migrated += 1
        rescue StandardError => e
          failed << { id: blob.id, key: blob.key, error: "#{e.class}: #{e.message}" }
          warn "ERROR blob_id=#{blob.id} key=#{blob.key} #{e.class}: #{e.message}"
        ensure
          puts "Progress #{processed}/#{total}" if (processed % 100).zero? || processed == total
        end
      end
    end

    puts "Done. migrated=#{migrated} skipped(existing)=#{skipped} failed=#{failed.size}"

    if failed.any?
      puts "Failed blobs:"
      failed.first(20).each do |entry|
        puts "  - blob_id=#{entry[:id]} key=#{entry[:key]} error=#{entry[:error]}"
      end
      abort "Migration finished with errors."
    end
  end

  desc "Show blob counts per Active Storage service_name"
  task service_report: :environment do
    total = ActiveStorage::Blob.count
    puts "Total blobs: #{total}"
    ActiveStorage::Blob.group(:service_name).count.each do |service_name, count|
      puts "  #{service_name}: #{count}"
    end
  end
end
