module Railgun

  class Attachment < StringIO

    attr_reader :filename, :content_type, :path,
                :original_filename, :overwritten_filename

    def initialize(attachment, *args)
      @path = ''
      @inline = args.detect { |opt| opt[:inline] }

      if @inline
        @filename = attachment.cid
      else
        @filename = attachment.filename
      end

      @original_filename = @filename

      if args.detect { |opt| opt[:filename] }
        @filename = opt[:filename]
      end

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
      if mb.nil?
        nil
      end

      if inline?
        mb.add_inline_image self, @filename
      else
        mb.add_attachment self, @filename
      end
    end

  end
end
