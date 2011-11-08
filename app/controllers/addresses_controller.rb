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
      qf: ['address_texts^10', 'text_syn^2', 'text_ngram'],
      fl: '',
      
      # relevancy influencers
      # percent of terms that must be present in the docs
      mm: '80%',
      # fields with extra boost for matches in proximity
      # pf: ['address_texts^5', 'text_syn^2', 'text_ngram'],
      # multiply the scores of other matching fields for a tie-breaker
      tie: 0.1,
      
      
      # perform highlighting on the catch-all text_hl field
      hl: true,
      :'hl.fl' => 'text_hl',
      :'hl.highlightMultiTerm' => true,
      :'hl.useFastVectorHighlighter' => 'on',
      
    }).tap do |search|
      
      # take care to filter the api key echoed in the response
      search['responseHeader']['params'].delete('api')
      
    end
  end

end
