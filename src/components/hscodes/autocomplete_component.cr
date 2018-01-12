module Hscodes::AutocompleteComponent
  private def search_hscodes
    h2 "Search records"
    para "You can find tax rates, imports or exports by country and year, and more."

    hscode_autocomplete "eg. Coffee, Gold, Petroleum, ..."
  end

  private def hscode_autocomplete(placeholder : String, selector = "search-hscodes")
    input class: "search-hscodes-autocomplete", name: selector, placeholder: placeholder

    script do
      raw %(
        new autoComplete({
          selector: 'input[name="#{selector}"]',
          source: function(term, response) {
            try { xhr.abort(); } catch(e){}
            xhr = $.getJSON('/hscodes/search', { term: term }, function(data) {
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
            var code = item.getAttribute('data-code');
            window.location.href = "/hscodes/" + code;
          }
        });

        document.getElementById('#{selector}').addEventListener('focus', (e) => {
          var dropdown = document.getElementsByClassName('autocomplete-search-hscodes')[0];
          dropdown.style.display = 'block';
        })
      )
    end
  end
end