class AddressesController < ApplicationController

  def index
    @search = $solr.select(params: { q: '*:*' })
  end

  def autocomplete
    render :json => perform_search
  end

protected

  def perform_search
    $solr.select(params: {
      
      # parameters for the dismax full-text component of this search
      q: params[:q].downcase,
      defType: 'dismax',
      qf: ['address_texts^10', 'text_ngram', 'text_syn'],
      mm: 0,
      
      # perform highlighting on the results
      hl: true,
      :'hl.fl' => 'address_texts',
      :'hl.highlightMultiTerm' => true
      
    }).tap do |search|
      
      # take care to filter the api key echoed in the response
      search['responseHeader']['params'].delete('api')
      
    end
  end

end
