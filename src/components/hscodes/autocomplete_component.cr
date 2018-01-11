module Hscodes::AutocompleteComponent
  private def search_hscodes
    h2 "Search records"
    para "You can find tax rates, imports or exports by country and year, and more."
    input id: "search-hscodes", name: "search-hscodes", placeholder: "eg. Coffee, Gold, Petroleum, ..."

    hscode_autocomplete
  end

  private def hscode_autocomplete
    script do
      raw %(
        new autoComplete({
          selector: 'input[name="search-hscodes"]',
          source: function(term, response) {
            console.log('query: ', term);

            try { xhr.abort(); } catch(e){}
            xhr = $.getJSON('/hscodes/search', { term: term }, function(data) {
              console.log('response: ', data);
              response(data);
            });
          },
          renderItem: function (hscode, search) {
            var item = hscode.description;
            search = search.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
            var re = new RegExp("(" + search.split(' ').join('|') + ")", "gi");
            return '<div class="autocomplete-suggestion" data-val="' + item + '" data-code="'+ hscode.code +'">'
              + '<div class="code">' + hscode.code + '</div>'
              + item.replace(re, "<b>$1</b>")
              + '</div>';
          },
          menuClass: "autocomplete-search-hscodes",
          onSelect: (e, term, item) => {
            console.log('term: ', term);
            console.log('item: ', item);
            console.log('e: ', e);
            var code = item.getAttribute('data-code');
            window.location.href = "/hscodes/" + code;
          }
        });

        document.getElementById('search-hscodes').addEventListener('focus', (e) => {
          var dropdown = document.getElementsByClassName('autocomplete-search-hscodes')[0];
          dropdown.style.display = 'block';
        })
      )
    end
  end
end