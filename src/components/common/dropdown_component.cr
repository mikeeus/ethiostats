module Common::DropdownComponent
  private def dropdown
    div class: "ets-dropdown" do
      div class: "dropbtn", onclick: "toggleDropdown('countries-dropdown')" do
        "Dropdown"
      end
      div id: "countries-dropdown", class: "dropdown-content" do
        link "link", to: "#"
      end
    end

    script do
      raw %(
        function toggleDropdown(selector) {
          document.getElementById(selector).classList.toggle("show");
        }

        // Close the dropdown menu if the user clicks outside of it
        window.onclick = function(event) {
          console.log('window clicked;')
          if (!event.target.matches('.dropbtn')) {
            console.log('not button clicked;')
            var dropdowns = document.getElementsByClassName("dropdown-content");
            var i;
            for (i = 0; i < dropdowns.length; i++) {
              var openDropdown = dropdowns[i];
              if (openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
              }
            }
          }
        }
      )
    end
  end
end