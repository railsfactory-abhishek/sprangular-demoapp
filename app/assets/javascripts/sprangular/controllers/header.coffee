Sprangular.controller "HeaderCtrl", (
  $scope,
  $location,
  Cart,
  Account,
  Catalog,
  Ad,
  Env,
  Flash,
  Status,
  Angularytics,
  $translate
) ->

  $scope.cart = Cart
  Catalog.taxonomies().then (taxonomies) ->
    $scope.taxonomies = taxonomies
  Ad.ads().then (ads) ->
    $scope.slides = ads
  $scope.account = Account
  $scope.env = Env
  $scope.search = {text: $location.search()['keywords']}

  $scope.goToMyAccount = ->
    $location.path '/account'

  $scope.logout = ->
    Account.logout()
      .then (content) ->
        Angularytics.trackEvent("Account", "Logout")
        $scope.$emit('account.logout')
        Flash.success 'app.logout_success'
        $location.path '/'

  $scope.login = ->
    $location.path '/sign-in'

  $scope.doSearch = ->
    Angularytics.trackEvent("Product", "Search", $scope.search.text)

    product = _.find $scope.lastSearch, (product) ->
                product.name == $scope.search.text

    if product
      $location.path "/products/#{product.slug}"
    else
      $location.search('keywords', $scope.search.text)
      $location.path "/products"

  $scope.getProducts = (search) ->
    return [] unless search
    Catalog.products(search, 1, pageSize: 3, ignoreLoadingIndicator: true)
      .then (products) ->
        $scope.lastSearch = products
