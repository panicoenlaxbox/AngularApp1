using Microsoft.AspNetCore.Mvc.Testing;
using Shouldly;
using System.Net.Http.Json;

namespace TestProject1;

public class WeatherForecastShould(WebApplicationFactory<Program> factory, ITestOutputHelper output) : IClassFixture<WebApplicationFactory<Program>>
{
    [Fact]
    public async Task return_weather_forecast()
    {
        var client = factory.CreateClient();

        using var response = await client.GetAsync("api/weatherforecast", TestContext.Current.CancellationToken);

        response.EnsureSuccessStatusCode();
        var data = (await response.Content.ReadFromJsonAsync<IEnumerable<WeatherForecast>>(cancellationToken: TestContext.Current.CancellationToken))!;
        output.WriteLine(string.Join(Environment.NewLine, data.Select(d => d)));
        data.ShouldNotBeEmpty();
    }
}
