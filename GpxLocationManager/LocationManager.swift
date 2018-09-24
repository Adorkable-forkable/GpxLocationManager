//
//  LocationManager.swift
//  GpxLocationManager
//
//  Created by Joshua Adams on 4/23/15.
//  Copyright (c) 2015 Josh Adams. All rights reserved.
//

import CoreLocation

open class LocationManager {
  private var gpxLocationManager: GpxLocationManager!
  private var cLLocationManager: CLLocationManager!

  public enum LocationManagerType {
    case gpxFile(String)
    case locations([CLLocation])
    case coreLocation

    init() {
      self = .coreLocation
    }
  }

  internal func on<Result>(gpx: (GpxLocationManager) -> Result, core: (CLLocationManager) -> Result) -> Result {
    switch locationManagerType {
    case .gpxFile, .locations:
        return gpx(self.gpxLocationManager)
    case .coreLocation:
        return core(self.cLLocationManager)
    }
  }

  internal func on(gpx: ((GpxLocationManager) -> Void)?, core: ((CLLocationManager) -> Void)?) {
    switch locationManagerType {
    case .gpxFile, .locations:
        gpx?(self.gpxLocationManager)
    case .coreLocation:
        core?(self.cLLocationManager)
    }
  }

  open func authorizationStatus() -> CLAuthorizationStatus {
    return self.on(gpx: { (_) in
        return GpxLocationManager.authorizationStatus()
    }, core: { (_) in
        return CLLocationManager.authorizationStatus()
    })
  }

  open var location: CLLocation? {
    return self.on(gpx: { (manager) in
        return manager.location
    }, core: { (manager) in
        return manager.location
    })
  }

  open weak var delegate: CLLocationManagerDelegate? {
    get {
      return self.on(gpx: { (manager) in
        return manager.delegate
      }, core: { (manager) in
        return manager.delegate
      })
    }
    set {
      self.on(gpx: { (manager) in
        manager.delegate = newValue
      }, core: { (manager) in
        manager.delegate = newValue
      })
    }
  }

  open var desiredAccuracy: CLLocationAccuracy {
    get {
      return self.on(gpx: { (manager) in
        return manager.desiredAccuracy
      }, core: { (manager) in
        return manager.desiredAccuracy
      })
    }
    set {
      self.on(gpx: { (manager) in
        manager.desiredAccuracy = newValue
      }, core: { (manager) in
        manager.desiredAccuracy = newValue
      })
    }
  }

  open var activityType: CLActivityType {
    get {
      return self.on(gpx: { (manager) in
        return manager.activityType
      }, core: { (manager) in
        return manager.activityType
      })
    }
    set {
      self.on(gpx: { (manager) in
        manager.activityType = newValue
      }, core: { (manager) in
        manager.activityType = newValue
      })
    }
  }

  open var distanceFilter: CLLocationDistance {
    get {
      return self.on(gpx: { (manager) in
        return manager.distanceFilter
      }, core: { (manager) in
        return manager.distanceFilter
      })
    }
    set {
      self.on(gpx: { (manager) in
        manager.distanceFilter = newValue
      }, core: { (manager) in
        manager.distanceFilter = newValue
      })
    }
  }

  open var pausesLocationUpdatesAutomatically: Bool {
    get {
      return self.on(gpx: { (manager) in
        return manager.pausesLocationUpdatesAutomatically
      }, core: { (manager) in
        return manager.pausesLocationUpdatesAutomatically
      })
    }
    set {
      self.on(gpx: { (manager) in
        manager.pausesLocationUpdatesAutomatically = newValue
      }, core: { (manager) in
        manager.pausesLocationUpdatesAutomatically = newValue
      })
    }
  }

  open var allowsBackgroundLocationUpdates: Bool {
    get {
      return self.on(gpx: { (manager) in
        return manager.allowsBackgroundLocationUpdates
      }, core: { (manager) in
        return manager.allowsBackgroundLocationUpdates
      })
    }
    set {
      self.on(gpx: { (manager) in
        manager.allowsBackgroundLocationUpdates = newValue
      }, core: { (manager) in
        manager.allowsBackgroundLocationUpdates = newValue
      })
    }
  }

  open func requestAlwaysAuthorization() {
    self.on(gpx: { (manager) in
      manager.requestAlwaysAuthorization()
    }, core: { (manager) in
      manager.requestAlwaysAuthorization()
    })
  }

  open func requestWhenInUseAuthorization() {
    self.on(gpx: { (manager) in
      manager.requestWhenInUseAuthorization()
    }, core: { (manager) in
      manager.requestWhenInUseAuthorization()
    })
  }

  open var secondLength: Double {
    get {
      return self.on(gpx: { (manager) in
        return manager.secondLength
      }, core: { (_) in
        return 1.0
      })
    }
    set {
      self.on(gpx: { (manager) in
        manager.secondLength = newValue
      }, core: nil)
    }
  }

  open func kill() {
    self.on(gpx: { (manager) in
      manager.kill()
    }, core: nil)
  }

  public let locationManagerType: LocationManagerType

  public func getInternalLocationManager() -> GpxLocationManager? {
    return self.on(gpx: { (manager) in
      return manager
    }, core: { (_) in
      return nil
    })
  }

  public func getInternalLocationManager() -> CLLocationManager? {
    return self.on(gpx: { (_) in
      return nil
    }, core: { (manager) in
      return manager
    })
  }

  public init(type: LocationManagerType) {
    locationManagerType = type
    switch type {
    case .gpxFile(let gpxFile):
      gpxLocationManager = GpxLocationManager()
      setLocations(gpxFile: gpxFile)
    case .locations(let locations):
      gpxLocationManager = GpxLocationManager()
      setLocations(locations: locations)
    case .coreLocation:
      cLLocationManager = CLLocationManager()
    }
  }

  public init() {
    locationManagerType = .coreLocation
    cLLocationManager = CLLocationManager()
  }
}

extension LocationManager {
  public func setLocations(gpxFile: String) {
    switch locationManagerType {
    case .gpxFile:
      gpxLocationManager.setLocations(gpxFile: gpxFile)
    case .locations:
      fatalError("locationManagerType of this instance is .locations but GPX filename was passed.")
    case .coreLocation:
      fatalError("locationManagerType of this instance is .coreLocation but GPX filename was passed.")
    }
  }

  public func setLocations(locations: [CLLocation]) {
    self.on(gpx: { (manager) in
      manager.setLocations(locations: locations)
    }, core: { (_) in
      fatalError("locationManagerType of this instance is .coreLocation but caller attempted to set locations.")
    })
  }
}

extension LocationManager {
  open func startMonitoringSignificantLocationChanges() {
    self.on(gpx: { (manager) in
      manager.startMonitoringSignificantLocationChanges()
    }, core: { (manager) in
      manager.startMonitoringSignificantLocationChanges()
    })
  }

  open func startUpdatingLocation() {
    self.on(gpx: { (manager) in
      manager.startUpdatingLocation()
    }, core: { (manager) in
      manager.startUpdatingLocation()
    })
  }

  open func stopUpdatingLocation() {
    self.on(gpx: { (manager) in
      manager.stopUpdatingLocation()
    }, core: { (manager) in
      manager.stopUpdatingLocation()
    })
  }

  open func allowDeferredLocationUpdates(untilTraveled distance: CLLocationDistance, timeout: TimeInterval) {
    self.on(gpx: { (manager) in
      manager.allowDeferredLocationUpdates(untilTraveled: distance, timeout: timeout)
    }, core: { (manager) in
      manager.allowDeferredLocationUpdates(untilTraveled: distance, timeout: timeout)
    })
  }

  open func disallowDeferredLocationUpdates() {
    self.on(gpx: { (manager) in
      manager.disallowDeferredLocationUpdates()
    }, core: { (manager) in
      manager.disallowDeferredLocationUpdates()
    })
  }
}

extension LocationManager {
  var monitoredRegions: Set<CLRegion> {
    return self.on(gpx: { (manager) in
      return manager.monitoredRegions
    }, core: { (manager) in
      return manager.monitoredRegions
    })
  }

  open func startMonitoring(for region: CLRegion) {
    self.on(gpx: { (manager) in
      manager.startMonitoring(for: region)
    }, core: { (manager) in
      manager.startMonitoring(for: region)
    })
  }

  open func stopMonitoring(for region: CLRegion) {
    self.on(gpx: { (manager) in
      manager.stopMonitoring(for: region)
    }, core: { (manager) in
      manager.stopMonitoring(for: region)
    })
  }
}

extension LocationManager {
  open var heading: CLHeading? {
    return self.on(gpx: { (manager) in
      return manager.heading
    }, core: { (manager) in
      return manager.heading
    })
  }

  open func startUpdatingHeading() {
    self.on(gpx: { (manager) in
      manager.startUpdatingHeading()
    }, core: { (manager) in
      manager.startUpdatingHeading()
    })
  }

  open func stopUpdatingHeading() {
    self.on(gpx: { (manager) in
      manager.stopUpdatingHeading()
    }, core: { (manager) in
      manager.stopUpdatingHeading()
    })
  }
}
