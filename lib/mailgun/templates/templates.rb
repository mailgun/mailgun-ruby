module Mailgun
  class Templates
    attr_accessor :client, :domain

    def initialize(client = Mailgun::Client.new, domain = Mailgun.domain)
      @client = client
      @domain = domain
    end

    # Public: List Templates
    #
    # options - a Hash of options
    #
    # Returns a Hash of the list of templates or nil
    def list(options = {})
      res = client.get("#{domain}/templates", options)
      res.to_h['items']
    end

    # Public: Get template information
    #
    # domain - a String of Domain name to find a template url for
    # name - a String identifying the template to get the URL for
    #
    # Returns a String of the url for the identified template or an
    #   empty String if one is not set
    def get(name)
      res = client.get("#{domain}/templates/#{name}")
      res.to_h
    rescue NoMethodError
      ''
    end
    alias_method :info, :get

    # Public: Add template
    #
    # name        - A String of the name of the template
    # description - A String of the description the template
    # template    - The content of the template
    # options     - A Hash of other options (:tag, :comment, :engine)
    #
    # Returns a Boolean of whether the template was created
    def create(name, description, template = '', options = {})
      res = client.post("#{domain}/templates", options.merge('name' => name, 'description' => description, 'template' => template))
      res.to_h
    end
    alias_method :add, :create

    # Public: Update the description of a template
    #
    # name        - A String of the name of the template
    # description - A String of the new description
    #
    # Returns a Boolean of the success
    def update(name, description)
      res = client.put("#{domain}/templates/#{name}", description: description)
      res.to_h
    rescue Mailgun::CommunicationError
      false
    end

    # Public: Add a new version of a template
    #
    # name     - A String of the name of the template
    # template - The content of the template
    # tag      - Tag for the version
    # options  - A Hash of other options (:active, :engine)
    #
    def add_version(name, template, tag, options)
      res = client.post("#{domain}/templates/#{name}/versions", options.merge(template: template, tag: tag))
      res.to_h
    end
    
    def delete(name)
      res = client.delete("#{domain}/templates/#{name}")
      res.to_h
    end
  end
end