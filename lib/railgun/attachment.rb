module Railgun
  class Attachment < StringIO
    attr_reader :filename, :content_type, :path,
                :original_filename, :overwritten_filename

    def initialize(attachment, *args)
      @path = ''
      @inline = args.detect { |opt| opt[:inline] }

      @filename = if @inline
                    attachment.cid
                  else
                    attachment.filename
                  end

      @original_filename = @filename

      @filename = opt[:filename] if args.detect { |opt| opt[:filename] }

      @overwritten_filename = @filename

      @content_type = attachment.content_type.split(';')[0]

      super attachment.body.decoded
    end

    def inline?
      @inline
    end

    def is_original_filename
      @original_filename == @overwritten_filename
    end

    def source_filename
      @filename
    end

    def attach_to_message!(mb)
      nil if mb.nil?

      if inline?
        mb.add_inline_image self, @filename
      else
        mb.add_attachment self, @filename
      end
    end
  end
end
