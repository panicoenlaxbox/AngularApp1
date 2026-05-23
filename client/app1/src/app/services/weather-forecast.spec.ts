import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';

import { WeatherForecastService } from './weather-forecast';

describe('WeatherForecastService', () => {
  let service: WeatherForecastService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [provideHttpClient()]
    });
    service = TestBed.inject(WeatherForecastService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
