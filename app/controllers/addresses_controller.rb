class AddressesController < ApplicationController

  def index
    @search = $solr.select(params: { q: '*:*' })
  end

  def autocomplete
    render :json => $solr.select(params: {
      q: params[:q].downcase,
      defType: 'dismax',
      qf: ['address_texts^10', 'text_ngram'],
      
      hl: true,
      :'hl.fl' => 'address_texts',
      :'hl.highlightMultiTerm' => true
    })
  end

end
