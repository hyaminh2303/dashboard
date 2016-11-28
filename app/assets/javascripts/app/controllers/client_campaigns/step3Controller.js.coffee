angular.module('client_campaigns_modifine').controller "step3Controller", [
  "$scope"
  "$http"
  "$timeout"
  "$collection"
  "Upload"
  "$validator"
  ($scope, $http, $timeout, $collection, Upload, $validator) =>
    MAX_FILE_SIZE = 6100000
    ACCEPTED_DIMENSIONS = []
    MAX_FILES = 10
    $scope.init = =>
      $scope.viewState.step = 3
      $scope.error = false
      $scope.viewState.nextButtonText = 'Complete'
    $scope.addBanners = (files, file, event) =>
      for file in files
        $scope.addBanner(file)

    $http.get(Routes.list_banner_sizes_path()).then (resp) =>
      ACCEPTED_DIMENSIONS = resp.data.map((obj) =>
        {width: parseInt(obj.size.split('x')[0]), height: parseInt(obj.size.split('x')[1])}
      )

    $scope.addBanner = (file) =>
      $scope.error = false
      if $scope.countBanners() >= MAX_FILES
        $scope.error =
          msg: "Cannot uplaod over #{MAX_FILES} file(s)."
        return
      $scope.generateThumb file, =>
        if file.size > MAX_FILE_SIZE
          $scope.error =
            msg: 'Your image size is larger than 60KB'
        else if !($scope.validBannerSize(file))
          $scope.error =
            msg: 'Your image is invalid'
        else
          Upload.upload(
            url: Routes.banners_path()
            data:
              name: file.name
              image: file
              client_booking_campaign_id: $scope.client_booking_campaign.id
          ).then ((resp) =>
            banner = {}
            banner.landing_url = resp.data.landing_url
            banner.image_url = resp.data.image_url
            banner.name = resp.data.name
            banner.id = resp.data.id

            $scope.client_booking_campaign.banners.push(banner)

          ), ((resp) =>
            console.log 'Error status: ' + resp.status
          ), (evt) =>
            progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
            console.log 'progress: ' + progressPercentage + '% ' + evt.config.data.image.name
        $scope.$apply()



    $scope.generateThumb = (file, cb) =>
      if file != null
        if file.type.indexOf('image') > -1
          $timeout =>
            fr = new FileReader
            fr.readAsDataURL file
            fr.onload = (e) =>
              $timeout =>
                file.dataUrl = e.target.result
                img = new Image
                img.onload = =>
                  file.width = img.width
                  file.height = img.height
                  cb()
                img.src = fr.result

    $scope.removeBanner = (banner, e) =>
      e.stopPropagation()
      if banner.id
        banner._destroy = true
      else
        $collection.remove($scope.client_booking_campaign.banners, banner)
      if $scope.countBanners() == 0
        $scope.error =
          msg: 'You need to upload at least one creative.'


    $scope.hasBanners = =>
      $scope.countBanners() > 0

    $scope.countBanners = =>
      $collection.select $scope.client_booking_campaign.banners, (banner) =>
        !banner._destroy
      .length

    $scope.stopClickFromContainer = (e) =>
      e.stopPropagation()
      return false

    $scope.closeAlert = =>
      $scope.error = false

    $scope.validBannerSize = (file) =>
      $collection.any ACCEPTED_DIMENSIONS, (i) ->
        i.width == file.width and i.height == file.height

    isURL = (str) ->
      pattern = new RegExp('^(https?:\\/\\/)?' + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.?)+[a-z]{2,}|' + '((\\d{1,3}\\.){3}\\d{1,3}))' + '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*' + '(\\?[;&a-z\\d%_.~+=-]*)?' + '(\\#[-a-z\\d_]*)?$', 'i')
      pattern.test str

    $scope.viewState.isValid = =>
      isValid = true
      if !$scope.skipOrNeedDesign()
        isValid = $scope.countBanners() > 0
      $scope.client_booking_campaign.banners.forEach (banner) =>
        if (banner.landing_url && !isURL(banner.landing_url)) || (banner.client_tracking_url &&!isURL(banner.client_tracking_url))
          isValid = false
          return

      return isValid

    $scope.getContactEmail = (email) =>
      if $scope.client_booking_campaign.contact_email
        $scope.client_booking_campaign.contact_email
      else
        $scope.client_booking_campaign.contact_email = email

    $scope.skipOrNeedDesign = =>
      $scope.client_booking_campaign.skip_upload_creatives || $scope.client_booking_campaign.need_yoose_help_design_creatives

    $scope.init()
]
