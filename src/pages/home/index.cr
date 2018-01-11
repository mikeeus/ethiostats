class Home::IndexPage < MainLayout
  include Charts::HomepageComponent

  def inner
    div class: "homepage-wrapper" do
      h1 "Ethiopian Trade Statistics"
      search_hscodes
      home_intro
      homepage_chart
    end
  end

  private def search_hscodes
    h2 "Search records"
    para "You can find tax rates, imports or exports by country and year, and more."
    input id: "search-hscodes", name: "search-hscodes", placeholder: "eg. Coffee, Gold, Petroleum, ..."

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

  private def home_intro
    para "The purpose of this site is to make Ethiopian import and export statistics available in a userfriendly and clear format in order to promote:"
    ul do
      li do
        h3 "Investment"
        para "assist potential investors discover opportunities for import substitution."
      end
      li do
        h3 "Growth"
        para "help businesses identify developing trends to guide decisions."
      end
      li do
        h3 "Research"
        para "serve as a reference for students, researchers and decision makers."
      end
    end
    para "You can search and select an HS Code from the table, select a country from the drop down in the header or check out one of the annual summaries from the dropdown link above. Good luck and happy browsing!"
    small do
      text "The data on this site is available to the public from the "
      link "Ethiopian Revenue and Customs Authority (ERCA)", to: "http://www.erca.gov.et/"
      text " and is updated every two months."
    end
  end
end
