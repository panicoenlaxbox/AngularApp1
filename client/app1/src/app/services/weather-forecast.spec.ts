import { TestBed } from '@angular/core/testing';

import { WeatherForecast } from './weather-forecast';

describe('WeatherForecast', () => {
  let service: WeatherForecast;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(WeatherForecast);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
